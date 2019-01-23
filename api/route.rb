require 'json'
require 'sinatra'
require './app/models/room'

default_dir = `pwd`.chomp

App.add_route('GET', '/', {}) do
  erb :index
end

App.add_route('GET', '/room/{id}', {
  "resourcePath" => "/Default",
  "summary" => "個別の部屋を取得",
  "nickname" => "room_id_get", 
  "responseClass" => "inline_response_200", 
  "endpoint" => "/room/{id}", 
  "notes" => "指定された部屋番号の情報を返します",
  "parameters" => [
    {
      "name" => "id",
      "description" => "部屋番号",
      "dataType" => "int",
      "paramType" => "path",
    },
    ]}) do
  cross_origin
  content_type :json
  room_data = RoomData.new(default_dir)
  room_data.room(params).to_json
end

App.add_route('POST', '/room/{id}/{temp}', {
  "resourcePath" => "/Default",
  "summary" => "温度をpost",
  "nickname" => "room_id_temp_post", 
  "responseClass" => "inline_response_200_1", 
  "endpoint" => "/room/{id}/{temp}", 
  "notes" => "温度を入力する",
  "parameters" => [
    {
      "name" => "id",
      "description" => "部屋番号",
      "dataType" => "int",
      "paramType" => "path",
    },
    {
      "name" => "temp",
      "description" => "温度",
      "dataType" => "number",
      "paramType" => "path",
    },
    ]}) do
  cross_origin

  ret = {}
  begin
    room_data = RoomData.new(default_dir)
    room_data.update(params)
    ret = { id: params[:id].to_i }
  rescue => e
    ret[:errors] = []
    ret[:errors] << e.message.to_s
  end
  content_type :json
  ret.to_json
end


App.add_route('GET', '/room', {
  "resourcePath" => "/Default",
  "summary" => "一覧情報",
  "nickname" => "rooms_get", 
  "responseClass" => "array[object]", 
  "endpoint" => "/rooms", 
  "notes" => "一覧で取得する ",
  "parameters" => [
    ]}) do
  cross_origin

  content_type :json
  room_data = RoomData.new(default_dir)
  room_data.rooms.to_json
end

