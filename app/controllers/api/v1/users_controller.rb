# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      
      # GET /api/v1/users
      def index
        @users = User.all
        render json: @users
      end
      
      # GET /api/v1/users/:id
      def show
        render json: @user
      end
      
      # POST /api/v1/users
      def create
        @user = User.new(user_params)
        
        if @user.save
          # Crear una cuenta por defecto para el usuario
          account_id = "#{@user.name}-0"
          @account = @user.accounts.create!(id: account_id, amount: 0)
          
          render json: { user: @user, account: @account }, status: :created
        else
          render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        head :no_content
      end
      
      # POST /api/v1/users/:id/set_current
      def set_current
        @user = User.find(params[:id])
        render json: @user
      end
      
      # POST /api/v1/users/new_user
      def new_user
        # Busca si ya existe un usuario con ese nombre
        @user = User.find_by(name: user_params[:name])
        
        if @user
          # Limpiar todas las cuentas y transacciones existentes
          @user.accounts.destroy_all
          
          # Crear una nueva cuenta
          account_id = "#{@user.name}-0"
          @account = @user.accounts.create!(id: account_id, amount: 0)
        else
          # Crear nuevo usuario
          @user = User.create!(name: user_params[:name])
          
          # Crear una cuenta por defecto
          account_id = "#{@user.name}-0"
          @account = @user.accounts.create!(id: account_id, amount: 0)
        end
        
        render json: { user: @user, account: @account }, status: :created
      end
      
      private
      
      def set_user
        @user = User.find(params[:id])
      end
      
      def user_params
        params.require(:user).permit(:name)
      end
    end
  end
end
