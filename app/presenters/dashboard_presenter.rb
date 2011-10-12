# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class DashboardPresenter < BasePresenter

  def change_password_link
    if current_user.change_default_password?
      h.content_tag(:h3, h.link_to("Le recomendamos cambiar su contraseña", h.default_password_users_path ) )
    end
  end

  def create_money_link
    if MoneyStore.org.empty?
      content_tag(:h3, "Por favor le recomendamos crear una #{h.link_to "cuenta bancaria", h.new_bank_path } o #{h.link_to "cuenta de caja", h.new_cash_path}".html_safe)
    end
  end

  def accounts_to_recieve
    tot_accounts = Account.org.to_recieve.group(:currency_id).sum(:amount)
    tot_incomes  = Income.org.approved.group(:currency_id).sum(:balance)
    keys = (tot_accounts.keys + tot_incomes.keys).uniq
  
    keys.map do |cur_id|
      s = tot_accounts[cur_id].to_f.abs + tot_incomes[cur_id].to_f
      [currencies[cur_id], s]
    end
  end

  def accounts_to_pay
    tot_accounts = Account.org.to_pay.group(:currency_id).sum(:amount)
    tot_incomes  = Buy.org.approved.group(:currency_id).sum(:balance)
    keys = (tot_accounts.keys + tot_incomes.keys).uniq
  
    keys.map do |cur_id|
      s = tot_accounts[cur_id].to_f.abs + tot_incomes[cur_id].to_f
      [currencies[cur_id], s]
    end
  end

  def pendent_conciliations
    AccountLedger.org.pendent.map do |al|
      [currencies[al.currency_id], al]
    end
  end

  def minimum_inventory
    @min_list ||= Stock.minimum_list
    @stores   ||= Hash[Store.org.where(:id => @min_list.keys).values_of(:id, :name)]
    @list     ||= @min_list.map {|k, v| [k, @stores[k], v]}
  end

  def minimum_list
    @min_list ||= Stock.minimum_list
  end

end