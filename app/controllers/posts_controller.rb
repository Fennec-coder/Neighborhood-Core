# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
end
