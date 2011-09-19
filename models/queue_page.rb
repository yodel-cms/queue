class QueuePage < Page
  respond_to :get do
    with :html do
      @task_count = site.tasks.count
      @delayed_task_count = site.tasks.where(due: {'$ne' => nil}, attempts: 0).count
      @instant_task_count = site.tasks.where(due: nil).count
      @failed_tasks = site.tasks.where(attempts: {'$gt' => 0}).all
      
      render_or_default(:html) do
        "<p>Sorry, a layout couldn't be found for this page</p>" # FIXME: better error message
      end
    end
  end
  
  respond_to :post do
    with :html do
      task = site.tasks.find(BSON::ObjectId.from_string(params['id']))
      if task
        task.due = nil
        task.locked = nil
        task.attempts = 0
        task.stack_trace = nil
        task.save
      end
      response.redirect(self.path)
    end
  end
end
