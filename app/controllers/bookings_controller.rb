class BookingsController < ApplicationController
  def show
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new
    authorize @booking
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new(booking_params)
    @booking.borrower = current_user
    @booking.listing = @listing
    if @booking.save
      raise
      redirect_to listings_path(@listing)
    else
      render :new
    end
    authorize @booking
  end



  def approve
    @booking = Booking.find(params[:id])
    authorize @booking

    @booking.update(approved: true)

    current_listing = @booking.listing
    all_bookings_for_my_listing = current_listing.bookings

    bookings_to_reject = all_bookings_for_my_listing.where(approved: nil)
    bookings_to_reject.update(approved: false)
    redirect_to dashboard_path
  end

  def reject
    @booking = Booking.find(params[:id])
    authorize @booking

    @booking.update(approved:false)
    redirect_to booking_path
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :return_date)
  end
end