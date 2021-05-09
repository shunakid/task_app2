class GuestReviewsController < ApplicationController

  def create

    @reservation = Reservation.where(
                    id: guest_review_params[:reservation_id],
                    room_id: guest_review_params[:room_id]
                   ).first

    if !@reservation.nil? && @reservation.room.user.id == guest_review_params[:host_id].to_i

      @has_reviewed = GuestReview.where(
                        reservation_id: @reservation.id,
                        host_id: guest_review_params[:host_id]
                      ).first

      if @has_reviewed.nil?
          @guest_review = current_user.guest_reviews.create(guest_review_params)
          flash[:success] = "レビューを作成しました"
      else
          flash[:success] = "予約済みです"
      end
    else
      flash[:alert] = "予約が見つかりません"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy

    redirect_back(fallback_location: request.referer, notice: "削除されました")
  end

  private
    def guest_review_params
      params.require(:guest_review).permit(:comment, :star, :room_id, :reservation_id, :host_id)
    end
end
