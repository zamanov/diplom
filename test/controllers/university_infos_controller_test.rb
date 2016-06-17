require 'test_helper'

class UniversityInfosControllerTest < ActionController::TestCase
  setup do
    @university_info = university_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:university_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create university_info" do
    assert_difference('UniversityInfo.count') do
      post :create, university_info: { address: @university_info.address, email: @university_info.email, founder_address: @university_info.founder_address, founder_director: @university_info.founder_director, founder_email: @university_info.founder_email, founder_name: @university_info.founder_name, founder_phone: @university_info.founder_phone, founder_site: @university_info.founder_site, fullname: @university_info.fullname, infodate: @university_info.infodate, regdate: @university_info.regdate, site: @university_info.site, telephone: @university_info.telephone, university_id: @university_info.university_id, worktime: @university_info.worktime }
    end

    assert_redirected_to university_info_path(assigns(:university_info))
  end

  test "should show university_info" do
    get :show, id: @university_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @university_info
    assert_response :success
  end

  test "should update university_info" do
    patch :update, id: @university_info, university_info: { address: @university_info.address, email: @university_info.email, founder_address: @university_info.founder_address, founder_director: @university_info.founder_director, founder_email: @university_info.founder_email, founder_name: @university_info.founder_name, founder_phone: @university_info.founder_phone, founder_site: @university_info.founder_site, fullname: @university_info.fullname, infodate: @university_info.infodate, regdate: @university_info.regdate, site: @university_info.site, telephone: @university_info.telephone, university_id: @university_info.university_id, worktime: @university_info.worktime }
    assert_redirected_to university_info_path(assigns(:university_info))
  end

  test "should destroy university_info" do
    assert_difference('UniversityInfo.count', -1) do
      delete :destroy, id: @university_info
    end

    assert_redirected_to university_infos_path
  end
end
