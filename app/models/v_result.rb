#coding: utf-8
class VResult < ActiveRecord::Base
  belongs_to :result
  has_one :bnf, as: :component, dependent: :destroy, autosave: true
  has_one :log, as: :component, autosave: true

end
