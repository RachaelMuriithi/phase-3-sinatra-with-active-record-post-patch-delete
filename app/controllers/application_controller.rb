class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/games' do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get '/games/:id' do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
      reviews: { only: [:comment, :score], include: {
        user: { only: [:name] }
      } }
    })
  end
  delete '/reviews/:id' do
    # find the review using the ID
    review = Review.find(params[:id])
    # delete the review
    review.destroy
    # send a response with the deleted review as JSON
    review.to_json
  end
  post '/reviews' do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id]
    )
    review.to_json
  end
  patch '/reviews/:id' do
    review = Review.find(params[:id])
    review.update(
      score: params[:score],
      comment: params[:comment]
    )
    review.to_json
  end
  # function EditReviewForm({ review, onUpdateReview }) {
  #   const [comment, setComment] = useState("");
  #   const [score, setScore] = useState("0");
  
  #   function handleSubmit(e) {
  #     e.preventDefault();
  #     fetch(`http://localhost:9292/reviews/${review.id}`, {
  #       method: "PATCH",
  #       headers: {
  #         "Content-Type": "application/json",
  #       },
  #       body: JSON.stringify({
  #         comment: comment,
  #         score: score,
  #       }),
  #     })
  #       .then((r) => r.json())
  #       .then((updatedReview) => onUpdateReview(updatedReview));
  #   }
  
  #   return <form onSubmit={handleSubmit}>{/* controlled form code here*/}</form>;
  # }
  # function ReviewForm({ userId, gameId, onAddReview }) {
  #   const [comment, setComment] = useState("");
  #   const [score, setScore] = useState("0");
  
  #   function handleSubmit(e) {
  #     e.preventDefault();
  #     fetch("http://localhost:9292/reviews", {
  #       method: "POST",
  #       headers: {
  #         "Content-Type": "application/json",
  #       },
  #       body: JSON.stringify({
  #         comment: comment,
  #         score: score,
  #         user_id: userId,
  #         game_id: gameId,
  #       }),
  #     })
  #       .then((r) => r.json())
  #       .then((newReview) => onAddReview(newReview));
  #   }
  
  #   return <form onSubmit={handleSubmit}>{/* controlled form code here*/}</form>;
  # }
#   function ReviewItem({ review, onDeleteReview }) {
#   function handleDeleteClick() {
#     fetch(`http://localhost:9292/reviews/${review.id}`, {
#       method: "DELETE",
#     })
#       .then((r) => r.json())
#       .then((deletedReview) => onDeleteReview(deletedReview));
#   }

#   return (
#     <div>
#       <p>Score: {review.score}</p>
#       <p>{review.comment}</p>
#       <button onClick={handleDeleteClick}>Delete Review</button>
#     </div>
#   );
# }
end
