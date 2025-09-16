# typed: strict

class CommunitiesController < BaseController
  extend T::Sig

  sig { override.void }
  def index
    super
  end

  sig { override.void }
  def show
    super
  end

  sig { override.void }
  def create
    super
  end

  sig { override.void }
  def destroy
    super
  end

  # GET /communities


  private

  sig { override.returns(Communities::ReadDto) }
  def read_dto
    Communities::ReadDto.new(titles: params[:titles])
  end

  sig { override.returns(Communities::CreateDto) }
  def create_dto
    Communities::CreateDto.new(title: params[:title], description: params[:description])
  end


  sig { override.returns(CommunitiesRepository) }
  def repository
    @repository ||= CommunitiesRepository.new
  end
end
