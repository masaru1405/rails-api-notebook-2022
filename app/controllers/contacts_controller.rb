class ContactsController < ApplicationController
   before_action :set_contact, only: [:show, :update, :destroy]

   def index
      @contacts = Contact.all
      render json: @contacts, methods: :hello
   end

   def show
      #render json: @contact, include: {kind: {only: [:id, :description]}}, except: :kind_id
      #render json: @contact, include: [:kind, :phones, :address]
      render json: @contact #, include: [:kind] #, meta: {author: "Kaio", }
   end

   def create
      @contact = Contact.new(contact_params)
      if @contact.save
         render json: @contact, include: [:kind, :phones, :address], status: :created
      else
         render json: @contact.errors, status: :unprocessable_entity
      end
   end

   def update
      if @contact.update(contact_params)
         render json: @contact, include: [:kind, :phones, :address]
      else
         render json: @contact.errors, status: :unprocessable_entity
      end
   end

   def destroy
      @contact.destroy
   end


   private
      def set_contact
         @contact = Contact.find(params[:id])
      end

      def contact_params
         params.require(:contact).permit(:name, :email, :birthdate, :kind_id, phones_attributes: [:id, :number, :_destroy], address_attributes: [:id, :street, :city])
      end
end
