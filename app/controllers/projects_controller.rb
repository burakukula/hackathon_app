class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    @token = Token.all
  end

  def new
    @project = Project.new
  end

  def show
    @projects = Project.all
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html {redirect_to root_path, notice: 'New project was created.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end

   def vote
    @project = Project.find(params[:project_id])
       if @project.votes.where(:token).exists?
         notice = 'You already voted'
       else
         @project.votes.create(:token, :voted => true)
         notice = 'Vote recorded'
       end
       @project.tokens_count = @project.tokens.find_all { |c| c.voted == false} .count
       redirect_to @project,  :method => :post
    end
end

  private

    def set_event
      @project = Project.new
    end

    def project_params
      params.require(:project).permit(:name, :description )
    end
end

