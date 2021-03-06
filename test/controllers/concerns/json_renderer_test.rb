# frozen_string_literal: true
require_relative '../../test_helper'

SingleCov.covered!

describe "JsonRenderer Integration" do
  describe "#render_json_with_includes" do
    let(:user) { users(:admin) }
    let(:json) { JSON.parse(@response.body) }

    before { stub_session_auth }

    it "renders without includes" do
      get '/deploys.json'
      assert_response :success
      json.keys.must_equal ['deploys']
      json['deploys'].first.keys.must_include "job_id"
      json['deploys'].first.keys.wont_include "job_ids"
      json['deploys'].first.keys.wont_include "job"
    end

    it "renders single includes" do
      get '/deploys.json', params: {includes: "job"}
      assert_response :success
      json.keys.must_equal ['deploys', 'jobs']
      json['deploys'].first.keys.must_include "job_id"
      json['deploys'].first.keys.wont_include "job_ids"
      json['deploys'].first.keys.wont_include "job"
      json['jobs'].first.keys.must_include "id"
    end

    it "renders multiple includes" do
      get '/deploys.json', params: {includes: "job,project"}
      assert_response :success
      json.keys.must_equal ['deploys', 'jobs', 'projects']
    end

    it "renders plural includes with _ids" do
      get '/users.json', params: {includes: "user_project_roles"}
      assert_response :success
      json.keys.must_equal ['users', 'user_project_roles']
      json['users'].first.keys.must_include 'user_project_roles_ids'
      ids = json['user_project_roles'].map { |upr| upr['id'] }
      ids.size.must_equal ids.uniq.size
    end

    it "shows a descriptive error to users that use unsupported includes" do
      get '/deploys.json', params: {includes: "nope"}
      assert_response :bad_request
      json.must_equal(
        "status" => 400,
        "error" => "Forbidden includes [nope] found, allowed includes are [job, project, user, stage]"
      )
    end
  end
end
