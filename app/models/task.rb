require 'concerns/encodable'

class Task < ActiveRecord::Base
  include Encodable

  attr_accessible :iactivity, :itask, :ntask, :nunidad, :currency_id, :cost, :nactivity

  has_many :payroll_logs
  belongs_to :currency

  def self.search(search_activity, search_code, search_desc, currency, page)
    query = Task.includes(:currency)
    query = query.where("nactivity LIKE ?", "#{search_activity}%") unless search_activity.empty?
    query = query.where("itask LIKE ?", "#{search_code}%") unless search_code.empty?
    query = query.where("ntask LIKE ?", "#{search_desc}%") unless search_desc.empty?
    query  = query.where(currency_id: currency) unless currency.empty?
    query.paginate(:page => page, :per_page => 10)
  end

  # Sync tasks
  def self.sync_fb
    
    created_records = 0
    updated_records = 0
    labmaests = Labmaest.includes(:actividad).find( :all, :select => ['iactividad', 'ilabor', 'nlabor', 'nunidad'] )

    labmaests.each do |task|
      
      theTask = Task.find_by_itask(task.ilabor)

      if theTask.nil?
        new_task = Task.new(:iactivity => task.iactividad,
                            :itask => task.ilabor,
                            :ntask => firebird_encoding(task.nlabor),
                            :nunidad => firebird_encoding(task.nunidad),
                            :nactivity=> firebird_encoding(task.actividad.try(:nactividad))
                            )
        if new_task.save
          created_records +=  1
        else  
          new_task.er.each do |error|
            Rails.logger.error "Error Creating task: #{task.ilabor}, Description: #{error}"
          end
        end
      else
        params = {
          :iactivity => task.iactividad,
          :ntask => firebird_encoding(task.nlabor),
          :nunidad => firebird_encoding(task.nunidad),
          :nactivity => firebird_encoding(task.actividad.try(:nactividad))
        }
        updated_records += 1 if theTask.update_attributes(params)
      end
    end

    tasks_fb = {}
    tasks_fb[:notice] = ["#{I18n.t('helpers.titles.tasksfb')}: #{created_records} 
                          #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    return tasks_fb
  end
end
