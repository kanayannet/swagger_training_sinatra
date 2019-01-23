
require 'json'

class RoomData

  def initialize
    @json_path = './data/rooms.json'
  end

  def rooms
    ret = []
    begin
      File.open(@json_path, 'r') do |f|
        ret = JSON.load(f)
      end
    rescue => e
    end
    ret
  end

  def room(params)
    ret = {}
    id = params[:id].to_i
    begin
      File.open(@json_path, 'r') do |f|
        JSON.load(f).each do |j|
          if j['id'] == id
            ret = j
            break
          end
        end
      end
    rescue => e
    end
    ret
  end

  def update(params)
    id = params[:id].to_i
    datas = self.rooms
    datas.each do |j|
      if j['id'] == id
        j['temp'] = params[:temp].to_i
        break
      end
    end
    # rename 方式で atomic write
    File.open("#{@json_path}.ren", 'w') do |f|
      JSON.dump(datas, f)
    end
    File.rename("#{@json_path}.ren", @json_path)
  end
end
