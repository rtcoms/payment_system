class Api::BaseApiController < ApplicationController
  protect_from_forgery with: :null_session
end