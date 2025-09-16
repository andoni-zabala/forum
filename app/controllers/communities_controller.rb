
# typed: strict

class CommunitiesController < ApplicationController
  extend T::Sig

  sig  { void }
  def index
    dto = read_dto
    @communities = repository.read(dto: dto)
    render json: @communities
  end

  # GET /communities/1
  def show
    render json: @community
  end

  private

  sig { returns(Communities::ReadDto) }
  def read_dto
    Communities::ReadDto.new(titles: params[:titles])
  end

  def repository
    @repository ||= CommunitiesRepository.new
  end
end
