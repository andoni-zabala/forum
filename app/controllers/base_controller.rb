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
    dto = id_dto
    entity = repository.find(dto: dto)

    render json: entity
  end

  sig { void }
  def create
    dto = create_dto
    entity = repository.create(dto: dto)

    render json: entity, status: :created
  end

  sig { void }
  def update
    dto = update_dto
    entity = repository.update(dto: dto)

    render json: entity
  end

  sig { void }
  def destroy
    dto = id_dto
    entity = repository.destroy(dto: dto)

    render json: entity
  end

  private

  sig { abstract.returns(T.untyped) }
  def repository; end

  sig { returns(IdDto) }
  def id_dto
    binding.pry
    IdDto.new(id: params[:id].to_i)
  end

  sig { abstract.returns(T::Struct) }
  def read_dto; end

  sig { abstract.returns(T::Struct) }
  def create_dto; end
end
