# typed: strict

class BaseController < ApplicationController
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { void }
  def index
    dto = read_dto
    entities = repository.read(dto: dto)

    render json: entities
  end

  sig { void }
  def show
    dto = show_dto(id: params[:id])
    entity = repository.find(dto: dto)

    render json: entity
  end

  private

  sig { abstract.returns(T.untyped) }
  def repository; end

  sig { abstract.returns(T::Struct) }
  def read_dto; end

  sig { params(id: String).returns(T::Struct) }
  def show_dto(id:)
    ShowDto.new(id: id.to_i)
  end
end
