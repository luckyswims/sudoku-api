class GameSerializer < ActiveModel::Serializer
  attributes :id, :board
  has_one :user
end
