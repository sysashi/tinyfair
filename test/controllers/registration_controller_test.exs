defmodule TinyFair.RegistrationControllerTest do
  use TinyFair.ConnCase

  alias TinyFair.Registration
  @valid_attrs %{email: "some content", line_id: "some content", password: "some content", phone: "some content", username: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, registration_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing registrations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "New registration"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @valid_attrs
    assert redirected_to(conn) == registration_path(conn, :index)
    assert Repo.get_by(Registration, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), registration: @invalid_attrs
    assert html_response(conn, 200) =~ "New registration"
  end

  test "shows chosen resource", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = get conn, registration_path(conn, :show, registration)
    assert html_response(conn, 200) =~ "Show registration"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, registration_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = get conn, registration_path(conn, :edit, registration)
    assert html_response(conn, 200) =~ "Edit registration"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = put conn, registration_path(conn, :update, registration), registration: @valid_attrs
    assert redirected_to(conn) == registration_path(conn, :show, registration)
    assert Repo.get_by(Registration, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = put conn, registration_path(conn, :update, registration), registration: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit registration"
  end

  test "deletes chosen resource", %{conn: conn} do
    registration = Repo.insert! %Registration{}
    conn = delete conn, registration_path(conn, :delete, registration)
    assert redirected_to(conn) == registration_path(conn, :index)
    refute Repo.get(Registration, registration.id)
  end
end
