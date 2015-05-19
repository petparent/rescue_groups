require_relative '../spec_helper'
require_relative '../../models/animal'

module RescueGroups
  describe Animal do
    describe '#initialize' do
      subject { described_class.new(attributes) }

      context 'known attributes are set' do
        let(:attributes) do
          {
            animalID: 12,
            animalDeclawed: true,
            animalName: :snuffles
          }
        end

        it 'sets the attributes' do
          expect(subject.id).to_not be_nil
          expect(subject.declawed).to_not be_nil
          expect(subject.name).to_not be_nil
        end
      end

      context 'known and unknown attributes are present' do
        let(:attributes) do
          {
            animalID: 12,
            animalDeclawed: true,
            animalName: :snuffles,
            animalFluffy: true,
            animalSmelly: false,
          }
        end

        it 'sets the attributes known' do
          expect(subject.id).to_not be_nil
          expect(subject.declawed).to_not be_nil
          expect(subject.name).to_not be_nil
        end

        it 'does not include the uknown attributes' do
          expect(subject.attributes).to_not include(:animalFluffy)
          expect(subject.attributes).to_not include(:animalSmelly)
        end
      end

      context 'only uknown attributes are present' do
        let(:attributes) do
          {
            animalFluffy: true,
            animalSmelly: false,
          }
        end

        it 'does not set them' do
          expect(subject.attributes).to_not include(:animalFluffy)
          expect(subject.attributes).to_not include(:animalSmelly)
        end
      end
    end

    describe '.where' do
      context 'when only id is present' do
        let(:id) { 1 }

        it 'calls find instead' do
          expect(described_class).to receive(:find).with(id)
          described_class.where(id: id)
        end
      end

      context 'with other conditions' do
        let(:conditions) { { breed: TEST_ANIMAL_BREED } }

        it 'adds conditions to search' do
          expect_any_instance_of(AnimalSearch)
            .to receive(:add_filter)
            .with(:animalBreed, :equal, TEST_ANIMAL_BREED)

          allow_any_instance_of(RemoteClient)
            .to receive(:post_and_respond) { TestResponse.new }

          described_class.where(conditions)
        end

        context 'when animals are found' do
          it 'does not error' do
            expect do
              described_class.where(breed: TEST_ANIMAL_BREED)
            end.to_not raise_error
          end

          it 'sets the breed correctly' do
            animals = described_class.where(breed: TEST_ANIMAL_BREED)

            expect(animals).to_not eq([])

            animals.each do |animal|
              expect(animal.breed).to_not be_nil
            end
          end
        end

        context 'when animals are not found' do
          it 'does not error' do
            expect do
              described_class.where(breed: NOT_FOUND_ANIMAL_BREED)
            end.to_not raise_error
          end

          it 'returns an empty array' do
            animals = described_class.where(breed: NOT_FOUND_ANIMAL_BREED)
            expect(animals).to eq([])
          end
        end
      end
    end
  end
end
