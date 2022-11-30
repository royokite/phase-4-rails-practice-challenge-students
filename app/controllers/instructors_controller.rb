class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response

    def index
        render json: Instructor.all, status: :ok, except: [:created_at, :updated_at]
    end

    def show
        instructor = find_instructor
        render json: instructor, status: :ok, except: [:created_at, :updated_at], include: :students
    end

    def create
        instructor = Instructor.create!(instructor_params)
        render json: instructor, status: :created
    end

    def update
        instructor = find_instructor
        instructor.update!(name: params[:name])
        render json: instructor, status: :ok
    end

    def destroy
        instructor = find_instructor
        instructor.destroy
        head :no_content
    end

    private

    def find_instructor
        Instructor.find(params[:id]) 
    end

    def instructor_params
        params.permit(:name)
    end

    def render_not_found_response
        render json: {error: "Instructor not found"}, status: :not_found
    end

    def render_invalid_record_response(invalid)
        render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

end
