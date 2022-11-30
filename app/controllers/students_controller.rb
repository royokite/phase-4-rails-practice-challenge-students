class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response

    def index
        render json: Student.all, status: :ok, except: [:created_at, :updated_at]
    end

    def show
        student = find_student
        render json: student, status: :ok, except: [:created_at, :updated_at]
    end

    def create
        student = Student.create!(student_params)
        render json: student, status: :created
    end

    def update
        student = find_student
        student.update!(student_params)
        render json: student, status: :ok
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

    private

    def find_student
        Student.find(params[:id]) 
    end

    def student_params
        params.permit(:name, :major, :age, :instructor_id)
    end

    def render_not_found_response
        render json: {error: "Student not found"}, status: :not_found
    end

    def render_invalid_record_response(invalid)
        render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
    
end
