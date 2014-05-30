# == Class: awstats::params
#
# The awstats configuration settings.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class awstats::params {

  case $::osfamily {
    'RedHat': {
      $package_name       = 'awstats'
      $package_require    = 'Yumrepo[epel]'
      $config_dir         = '/etc/awstats'
      $data_dir           = '/var/lib/awstats'
      $apache_user        = 'apache'
      $apache_group       = 'apache'
      $apache_confd_dir   = '/etc/httpd/conf.d'

      $vhost_config_defaults = {
        'LogType' => 'W',
        'LogFormat' => '1',
        'LogSeparator' => ' ',
        'DNSLookup' => '2',
        'DirData' => '/var/lib/awstats',
        'DirCgi' => '/awstats',
        'DirIcons' => '/awstatsicons',
        'AllowToUpdateStatsFromBrowser' => '0',
        'AllowFullYearView' => '2',
        'EnableLockForUpdate' => '1',
        'DNSStaticCacheFile' => 'dnscache.txt',
        'DNSLastUpdateCacheFile' => 'dnscachelastupdate.txt',
        'SkipDNSLookupFor' => '',
        'AllowAccessFromWebToAuthenticatedUsersOnly' => '0',
        'AllowAccessFromWebToFollowingAuthenticatedUsers' => '',
        'AllowAccessFromWebToFollowingIPAddresses' => '',
        'CreateDirDataIfNotExists' => '0',
        'BuildHistoryFormat' => 'text',
        'BuildReportFormat' => 'html',
        'SaveDatabaseFilesWithPermissionsForEveryone' => '0',
        'PurgeLogFile' => '0',
        'ArchiveLogRecords' => '0',
        'KeepBackupOfHistoricFiles' => '0',
        'DefaultFile' => 'index.php index.html',
        'SkipHosts' => '127.0.0.1',
        'SkipUserAgents' => '',
        'SkipFiles' => '',
        'SkipReferrersBlackList' => '',
        'OnlyHosts' => '',
        'OnlyUserAgents' => '',
        'OnlyUsers' => '',
        'OnlyFiles' => '',
        'NotPageList' => 'css js class gif jpg jpeg png bmp ico rss xml swf',
        'ValidHTTPCodes' => '200 304',
        'ValidSMTPCodes' => '1 250',
        'AuthenticatedUsersNotCaseSensitive' => '0',
        'URLNotCaseSensitive' => '0',
        'URLWithAnchor' => '0',
        'URLQuerySeparators' => '?;',
        'URLWithQuery' => '0',
        'URLWithQueryWithOnlyFollowingParameters' => '',
        'URLWithQueryWithoutFollowingParameters' => '',
        'URLReferrerWithQuery' => '0',
        'WarningMessages' => '1',
        'ErrorMessages' => '',
        'DebugMessages' => '0',
        'NbOfLinesForCorruptedLog' => '50',
        'WrapperScript' => '',
        'DecodeUA' => '0',
        'MiscTrackerUrl' => '/js/awstats_misc_tracker.js',
        'LevelForBrowsersDetection' => '2',
        'LevelForOSDetection' => '2',
        'LevelForRefererAnalyze' => '2',
        'LevelForRobotsDetection' => '2',
        'LevelForSearchEnginesDetection' => '2',
        'LevelForKeywordsDetection' => '2',
        'LevelForFileTypesDetection' => '2',
        'LevelForWormsDetection' => '0',
        'UseFramesWhenCGI' => '1',
        'DetailedReportsOnNewWindows' => '1',
        'Expires' => '3600',
        'MaxRowsInHTMLOutput' => '1000',
        'Lang' => 'auto',
        'DirLang' => './lang',
        'ShowMenu' => '1',
        'ShowSummary' => 'UVPHB',
        'ShowMonthStats' => 'UVPHB',
        'ShowDaysOfMonthStats' => 'VPHB',
        'ShowDaysOfWeekStats' => 'PHB',
        'ShowHoursStats' => 'PHB',
        'ShowDomainsStats' => 'PHB',
        'ShowHostsStats' => 'PHBL',
        'ShowAuthenticatedUsers' => '0',
        'ShowRobotsStats' => 'HBL',
        'ShowWormsStats' => '0',
        'ShowEMailSenders' => '0',
        'ShowEMailReceivers' => '0',
        'ShowSessionsStats' => '1',
        'ShowPagesStats' => 'PBEX',
        'ShowFileTypesStats' => 'HB',
        'ShowFileSizesStats' => '0',
        'ShowDownloadsStats' => 'HB',
        'ShowOSStats' => '1',
        'ShowBrowsersStats' => '1',
        'ShowScreenSizeStats' => '0',
        'ShowOriginStats' => 'PH',
        'ShowKeyphrasesStats' => '1',
        'ShowKeywordsStats' => '1',
        'ShowMiscStats' => 'a',
        'ShowHTTPErrorsStats' => '1',
        'ShowSMTPErrorsStats' => '0',
        'ShowClusterStats' => '0',
        'AddDataArrayMonthStats' => '1',
        'AddDataArrayShowDaysOfMonthStats' => '1',
        'AddDataArrayShowDaysOfWeekStats' => '1',
        'AddDataArrayShowHoursStats' => '1',
        'IncludeInternalLinksInOriginSection' => '0',
        'MaxNbOfDomain' => '10',
        'MinHitDomain' => '1',
        'MaxNbOfHostsShown' => '10',
        'MinHitHost' => '1',
        'MaxNbOfLoginShown' => '10',
        'MinHitLogin' => '1',
        'MaxNbOfRobotShown' => '10',
        'MinHitRobot' => '1',
        'MaxNbOfDownloadsShown' => '10',
        'MinHitDownloads' => '1',
        'MaxNbOfPageShown' => '10',
        'MinHitFile' => '1',
        'MaxNbOfOsShown' => '10',
        'MinHitOs' => '1',
        'MaxNbOfBrowsersShown' => '10',
        'MinHitBrowser' => '1',
        'MaxNbOfScreenSizesShown' => '5',
        'MinHitScreenSize' => '1',
        'MaxNbOfWindowSizesShown' => '5',
        'MinHitWindowSize' => '1',
        'MaxNbOfRefererShown' => '10',
        'MinHitRefer' => '1',
        'MaxNbOfKeyphrasesShown' => '10',
        'MinHitKeyphrase' => '1',
        'MaxNbOfKeywordsShown' => '10',
        'MinHitKeyword' => '1',
        'MaxNbOfEMailsShown' => '20',
        'MinHitEMail' => '1',
        'FirstDayOfWeek' => '1',
        'ShowFlagLinks' => '',
        'ShowLinksOnUrl' => '1',
        'UseHTTPSLinkForUrl' => '',
        'MaxLengthOfShownURL' => '64',
        'HTMLHeadSection' => '',
        'HTMLEndSection' => '',
        'MetaRobot' => '0',
        'Logo' => 'awstats_logo6.png',
        'LogoLink' => 'http://awstats.sourceforge.net',
        'BarWidth' => '260',
        'BarHeight' => '90',
        'StyleSheet' => '',
        'color_Background' => 'FFFFFF',
        'color_TableBGTitle' => 'CCCCDD',
        'color_TableTitle' => '000000',
        'color_TableBG' => 'CCCCDD',
        'color_TableRowTitle' => 'FFFFFF',
        'color_TableBGRowTitle' => 'ECECEC',
        'color_TableBorder' => 'ECECEC',
        'color_text' => '000000',
        'color_textpercent' => '606060',
        'color_titletext' => '000000',
        'color_weekend' => 'EAEAEA',
        'color_link' => '0011BB',
        'color_hover' => '605040',
        'color_u' => 'FFAA66',
        'color_v' => 'F4F090',
        'color_p' => '4477DD',
        'color_h' => '66DDEE',
        'color_k' => '2EA495',
        'color_s' => '8888DD',
        'color_e' => 'CEC2E8',
        'color_x' => 'C1B2E2',
        'ExtraTrackedRowsLimit' => '500',
      }
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
