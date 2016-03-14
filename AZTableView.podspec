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
  s.requires_arc = true
  s.default_subspec = "All"

  s.subspec "All" do |sp|
    sp.dependency 'AZTableView/Core'
  end

  s.subspec "Core" do |sp|
    sp.dependency 'YYWebImage'
    sp.resources = 'AZTableView/*.{lproj,bundle}'
    sp.source_files  = 'AZTableView', 'YYModel'
    sp.exclude_files = 'AZTableViewExample'
  end

end
