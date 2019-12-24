class User < ApplicationRecord

    def show

    end

    def create

    end

    def update

    end

    def destroy

    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :email, :password)
    end
end
