package the_street.sahayog_sathi_donor.dao;

import the_street.sahayog_sathi_donor.model.Donation;

import java.util.ArrayList;

public interface DonationInterface {
    //Insert a new donation. Returns true on success.
    boolean insertDonation(Donation donation);

    //Fetch a single donation by its primary key.
    Donation getDonationById(int donationId);

    //Fetch all donations belonging to a specific donor.
    ArrayList<Donation> getDonationsByDonorId(int donorId);

    //Update all editable fields of a donation.
    boolean updateDonation(Donation donation);

    //Cancel a donation and set status to CANCELLED.
    boolean cancelDonation(int donationId, int donorId);

    //Count total donations for a donor.
    int countDonationsByDonor(int donorId);

    //Count donations by status for a specific donor.
    int countDonationsByDonorAndStatus(int donorId, String status);
}