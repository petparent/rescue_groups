class OrganizationField
  FIELDS = {
    about:                     :orgAbout,
    adoption_process:          :orgAdoptionProcess,
    adoption_url:              :orgAdoptionUrl,
    common_application_accept: :orgCommonapplicationAccept,
    donation_url:              :orgDonationUrl,
    email:                     :orgEmail,
    facebook_url:              :orgFacebookUrl,
    fax:                       :orgFax,
    id:                        :orgID,
    location:                  :orgLocation,
    location_address:          :orgAddress,
    location_city:             :orgCity,
    location_country:          :orgCountry,
    # location_distance:         :orgLocationDistance, # Seems to have been removed
    location_postal:           :orgPostalcode,
    location_state:            :orgState,
    location_zip_plus_4:       :orgPlus4,
    meet_pets:                 :orgMeetPets,
    name:                      :orgName,
    phone:                     :orgPhone,
    serve_areas:               :orgServeAreas,
    services:                  :orgServices,
    sponsorship_url:           :orgSponsorshipUrl,
    type:                      :orgType,
    website_url:               :orgWebsiteUrl,
  }

  def self.all
    FIELDS.values
  end
end
