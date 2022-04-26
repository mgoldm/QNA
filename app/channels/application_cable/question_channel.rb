class QuestionsChannel
  def follow
    stream_from "questions"
  end
end
