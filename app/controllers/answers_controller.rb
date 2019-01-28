class AnswersController < ApplicationController
  helper_method :question
  helper_method :answer

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question, notice: "Your answer have been successfully added"
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
       redirect_to question, notice: "Your answer have been successfully updated"
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to question, notice: "Answer deleted"
    else 
      redirect_to question, notice: "No access to delete this answer"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end


  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end