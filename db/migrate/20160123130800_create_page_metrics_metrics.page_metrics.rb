# This migration comes from page_metrics (originally 20151105170502)
class CreatePageMetricsMetrics < ActiveRecord::Migration
  def change
    create_table :page_metrics_metrics do |t|
      t.string :name
      t.json :payload
      t.timestamps
    end
  end
end
