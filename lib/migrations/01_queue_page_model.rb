class QueuePageModelMigration < Migration
  def self.up(site)
    site.pages.create_model :queue_pages do |queue_pages|
      queue_pages.record_class_name = 'QueuePage'
      queue_pages.allowed_children = []
      queue_pages.allowed_parents = []
      queue_pages.hide_in_admin = true
    end
    
    # default queue page
    home_page = site.pages.where(path: '/').first
    qp = site.queue_pages.new
    qp.parent = home_page
    qp.title = "Queue"
    qp.save
  end
  
  def self.down(site)
    site.queue_pages.destroy
  end
end
