module VersionsHelper
  def whodunnit(version)
    User.find(version.whodunnit).name
  end
end
