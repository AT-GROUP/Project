#coding: utf-8
class Forwards2Controller < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index

  end
# def getfile
#   time = Time.now.utc.to_i 
#   Dir.mkdir('public/uploads/JSON/forward/'+params[:id]) unless File.exists?('public/uploads/JSON/forward/'+params[:id])
#   f = File.open('public/uploads/JSON/forward/'+params[:id]+'/'+time.to_s+'.json', 'w+')
#   f.puts(params[:trace])
#   f.close()
#   if params[:end]=='no' 
#  @results = Result.new()
#  @results.action = 'forward'
#  @results.user = User.find(params[:id])
#  @results.startfile = time.to_s+'.json'
#  @results.timebegin = time
#  @results.save()
#  render :text => "Конфигурация сохранена"
#   else
# @results = Result.where('user_id='+params[:id]).order('id DESC').only(:order, :where).limit(1).take!

#  @results.timeend = time
#  @results.endfile = time.to_s+'.json'
#  @results.result = params[:e]
#  @results.save()
#  render :text => "Тестирование закончено"
#  end
  def saveResult
    @user = User.find (session["user_id"])
    date = Time.now.to_formatted_s(:short)
    result = Fbresult.new
    result.fio = @user.student.fio
    result.fb = "Прямой"
    result.result = params[:result]
    result.group = @user.student.group.number
    result.save
  end
  def results
    @results = Fbresult.all
  end

end
