Pod::Spec.new do |s|
  s.name         = "KMYDraggableCollectionView"
  s.version      = "0.1"
  s.summary      = "Extension for the UICollectionView and UICollectionViewLayout that allows a user to move items with drag and drop."
  s.homepage     = "https://github.com/karmeye/KMYDraggableCollectionView"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = [ 'Luke Scott', 'Karmeye' ]
  s.source       = { :git => "https://github.com/karmeye/KMYDraggableCollectionView.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Source/*.{h,m}'

end
