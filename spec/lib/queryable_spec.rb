require_relative '../spec_helper'
require_relative '../../lib/queryable'

class TestClass
  FIELDS = {}
  include RescueGroups::Queryable
end

module RescueGroups
  describe Queryable do
    subject { TestClass.new }

    before do
      allow(TestClass).to receive(:object_type)
      allow(TestClass).to receive(:object_fields) { TestClass }
      allow(TestClass).to receive_message_chain(:object_fields, :all)
    end

    describe '.find' do
      before do
        allow(TestClass)
          .to receive_message_chain(:api_client, :post_and_respond) { response }
      end

      context 'response is successful' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'ok', 'data' => data })
        end

        before do
          allow(response).to receive(:success?) { true }
        end

        context 'data is returned' do
          let(:data) { [{ foo: :bar }] }

          it 'calls new with the data' do
            expect(TestClass).to receive(:new).with(data.first)
            response = TestClass.find(anything)
            expect(response).to_not be_a(Array)
          end

          context 'multiple ids are returned' do
            let(:data) { [{ foo: :bar }, { baz: :qux }] }

            it 'returns an array of objects' do
              expect(TestClass).to receive(:new).twice
              response = TestClass.find([anything, anything])
              expect(response).to be_a(Array)
              expect(response.length).to eq(2)
            end
          end
        end

        context 'no data is returned' do
          let(:data) { nil }
          it 'raises an exception' do
            expect do
              TestClass.find(anything)
            end.to raise_error(/Unable to find/)
          end
        end
      end

      context 'response is not successful' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'error', 'data' => [{ foo: :bar }] })
        end

        it 'raises an exception' do
          expect do
            TestClass.find(anything)
          end.to raise_error(/Unable to find/)
        end
      end
    end

    describe '.where' do
      before do
        obj = Object.new
        allow(obj).to receive(:as_json) { {} }
        allow(TestClass).to receive_message_chain(:search_engine_class, :new) { obj }
        allow(TestClass)
          .to receive_message_chain(:api_client, :post_and_respond) { response }
      end

      context 'response is successful' do
        context 'data is returned' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
          end

          it 'returns the data as an array' do
            expect(TestClass).to receive(:new).twice
            response = TestClass.where(anything: anything)
            expect(response).to be_a(Array)
          end
        end

        context 'no data is returned' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'data' => { } })
          end

          it 'returns an empty array' do
            response = TestClass.where(anything: anything)
            expect(response).to eq([])
          end
        end
      end

      context 'response is not successful' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'error', 'data' => nil })
        end

        it 'raises error' do
          expect do
            TestClass.where(anything: anything)
          end.to raise_error(/Problem with request/)
        end
      end
    end
  end
end