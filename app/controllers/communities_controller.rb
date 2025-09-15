
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

  # Only allow a list of trusted parameters through.
  def community_params
    params.expect(community: [ :title, :description ])
  end

  sig { returns(Communities::ReadDto) }
  def read_dto
    Communities::ReadDto.new(title: params[:title])
  end

  def repository
    @repository ||= CommunitiesRepository.new
  end
end
