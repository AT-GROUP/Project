class ExtensionDatabase

  module ExtensionType
    Knowledge = 1
    Psycho = 2
    Skill = 4
    Other = 8
  end

  class ATExtension
    attr_accessor :name, :controller_class, :ext_type, :description, :tasks
    attr_accessor :generate_state, :task_description, :task_exec_path


    AcceptableActions = {
      ExtensionType::Knowledge => ["extract-knowledge"],
      ExtensionType::Psycho => [],
      ExtensionType::Skill => ["extract-skill"],
      ExtensionType::Other => ["execute-development-step"]
    }

    def get_task_description(leaf_id)
      return task_description.call(leaf_id)
    end

    def get_task_exec_path(pddl_act, leaf_id)
      return task_exec_path.call(pddl_act, leaf_id)
    end

    def accepts_action(action_name)
      return AcceptableActions[@ext_type].include?(action_name)
    end

    def accepts_task(task_name)
      return @tasks.include?(task_name)
    end

    def self.get_acceptable_actions(type)
      return AcceptableActions[type]
    end
  end

  @@singleton = nil
  attr_accessor :extensions

  def initialize(*args)
    self.extensions = Array.new
    @@singleton = self
  end

  def add(new_ext_name, controller_class)
    new_ext = controller_class.create_extension() 

    new_ext.name = new_ext_name
    new_ext.controller_class = controller_class

    self.extensions.push(new_ext)
  end

  def self.get_extension(ext_name)
    return self.extensions[0]
  end

  def self.get_task_description(task_type, leaf_id)
    #Find suitable extension
    found_ext = nil
    @@singleton.extensions.each do |ext|
      if((ext.ext_type == task_type) && (ext.accepts_task(leaf_id)))
        found_ext = ext
        break
      end
    end

    if(found_ext == nil)
      return "?"
    else
      return found_ext.description
    end
  end


  def self.generate_state(week_id, mode_id, schedule)
    state = PlanningState.new
    PlanningState.transaction do

      @@singleton.extensions.each do |ext|
        ext.generate_state.call(mode_id, week_id, schedule, state)
      end

      state.save
    end

    return state
  end

  def self.get_extension_for_task(action, leaf_id)
    @@singleton.extensions.each do |ext|
      if(ext.accepts_action(action) && ext.accepts_task(leaf_id))
        return ext
      end
    end

    return nil
  end
end

