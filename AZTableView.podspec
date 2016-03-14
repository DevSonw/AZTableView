Pod::Spec.new do |s|

  s.name         = "AZTableView"
  s.version      = "0.1.0"
  s.summary      = "Highly customizable UITableView"

  s.description  = <<-DESC
                   Highly customizable UITableView
                   DESC

  s.homepage     = "https://github.com/zhixingapp/AZTableView"
  s.license      = "MIT"
  s.author       = { "Arron zhang" => "arronzhang@me.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/zhixingapp/AZTableView.git", :tag => s.version.to_s }
  s.source_files  = 'AZTableView', 'YYModel'
  s.exclude_files = 'AZTableViewExample'
  s.requires_arc = true

  s.dependency 'YYWebImage'

end
