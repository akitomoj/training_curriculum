class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_Week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(get_plans)
    redirect_to action: :index
  end

  private

  def get_plans
    params.require(:calendars).permit(:date, :plan)
  end

  def get_Week
    weekdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    # 日付の足し算は可能か？

    7.times do |x|
      today_plans = []
      # plan にplans配列の計算結果を代入
      plans.map do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      # ifでは、dateレコードが、特定の日（1週間）の場合
      # today_plansにplanレコードを代入
      end
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, wday: weekdays[(@todays_date + x).wday], plans: today_plans }
      @week_days.push(days)
    end

  end
end
