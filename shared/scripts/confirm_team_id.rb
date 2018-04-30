# open project using xcodeproj from Cocoapods
require 'xcodeproj'
project_path = 'voluxe-customer.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# expected values
targetName = "voluxe-customer"
appStoreConfigNamePrefix = "AppStore"
appStoreTeamID = "DTE5P7QRF9"
enterpriseTeamID = "396JF7EZ43"

if project.targets.empty?
    abort("FAILED: no targets in project")
end

# TODO should fail if expected target name not found
# TODO should fail if expected config name not found
# aborts if expected team ID are not found
project.targets.each do |target|
    if target.name == targetName
        target.build_configurations.each do |config|
            teamID = config.build_settings["DEVELOPMENT_TEAM"]
            
            # all AppStore_ configs require App Store Team ID
            if config.name.start_with?(appStoreConfigNamePrefix) && teamID != appStoreTeamID
                puts "FAILED: could not confirm AppStore Team ID"
                string = config.name + ": expected Team ID " + appStoreTeamID + ", found " + teamID
                abort(string)
                
            # all other configs require Enterprise Team ID
            elsif config.name.start_with?(appStoreConfigNamePrefix) == false && teamID != enterpriseTeamID
                puts "FAILED: could not confirm Enterprise Team ID"
                string = config.name + ": expected Team ID " + enterpriseTeamID + ", found " + teamID
                abort(string)
            end
        end
    end
end
