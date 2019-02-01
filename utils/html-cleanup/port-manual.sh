#!/bin/bash

cd src
for HtmlCleanupFilename in *.html; do
	../html-cleanup.py $HtmlCleanupFilename ../dst/$HtmlCleanupFilename.out ../../../
done
cd ../dst


# Overview
pandoc -f html -t rst Overview.html.out -o ../../../docs/rst/Overview.html.out.rst
pandoc -f html -t rst HighThroughputComputingHTCanditsRequirements.html.out -o ../../../docs/rst/HighThroughputComputingHTCanditsRequirements.html.out.rst
pandoc -f html -t rst HTCondorsPower.html.out -o ../../../docs/rst/HTCondorsPower.html.out.rst
pandoc -f html -t rst ExceptionalFeatures.html.out -o ../../../docs/rst/ExceptionalFeatures.html.out.rst
pandoc -f html -t rst CurrentLimitations.html.out -o ../../../docs/rst/CurrentLimitations.html.out.rst
pandoc -f html -t rst Availability.html.out -o ../../../docs/rst/Availability.html.out.rst
pandoc -f html -t rst ContributionsandAcknowledgments.html.out -o ../../../docs/rst/ContributionsandAcknowledgments.html.out.rst
pandoc -f html -t rst ContactInformation.html.out -o ../../../docs/rst/ContactInformation.html.out.rst
pandoc -f html -t rst PrivacyNotice.html.out -o ../../../docs/rst/PrivacyNotice.html.out.rst

# User's Manual
pandoc -f html -t rst UsersManual.html.out -o ../../../docs/rst/UsersManual.html.out.rst
pandoc -f html -t rst WelcometoHTCondor.html.out -o ../../../docs/rst/WelcometoHTCondor.html.out.rst
pandoc -f html -t rst Introduction.html.out -o ../../../docs/rst/Introduction.html.out.rst
pandoc -f html -t rst MatchmakingwithClassAds.html.out -o ../../../docs/rst/MatchmakingwithClassAds.html.out.rst
pandoc -f html -t rst RunningaJobtheStepsToTake.html.out -o ../../../docs/rst/RunningaJobtheStepsToTake.html.out.rst
pandoc -f html -t rst SubmittingaJob.html.out -o ../../../docs/rst/SubmittingaJob.html.out.rst
pandoc -f html -t rst ManagingaJob.html.out -o ../../../docs/rst/ManagingaJob.html.out.rst
pandoc -f html -t rst PrioritiesandPreemption.html.out -o ../../../docs/rst/PrioritiesandPreemption.html.out.rst
pandoc -f html -t rst JavaApplications.html.out -o ../../../docs/rst/JavaApplications.html.out.rst
pandoc -f html -t rst ParallelApplicationsIncludingMPIApplications.html.out -o ../../../docs/rst/ParallelApplicationsIncludingMPIApplications.html.out.rst
pandoc -f html -t rst DAGManApplications.html.out -o ../../../docs/rst/DAGManApplications.html.out.rst
pandoc -f html -t rst VirtualMachineApplications.html.out -o ../../../docs/rst/VirtualMachineApplications.html.out.rst
pandoc -f html -t rst DockerUniverseApplications.html.out -o ../../../docs/rst/DockerUniverseApplications.html.out.rst
pandoc -f html -t rst TimeSchedulingforJobExecution.html.out -o ../../../docs/rst/TimeSchedulingforJobExecution.html.out.rst
pandoc -f html -t rst SpecialEnvironmentConsiderations.html.out -o ../../../docs/rst/SpecialEnvironmentConsiderations.html.out.rst
pandoc -f html -t rst PotentialProblems.html.out -o ../../../docs/rst/PotentialProblems.html.out.rst

# Administrator's Manual
pandoc -f html -t rst AdministratorsManual.html.out -o ../../../docs/rst/AdministratorsManual.html.out.rst
pandoc -f html -t rst Introduction1.html.out -o ../../../docs/rst/Introduction1.html.out.rst
pandoc -f html -t rst InstallationStartUpShutDownandReconfiguration.html.out -o ../../../docs/rst/InstallationStartUpShutDownandReconfiguration.html.out.rst
pandoc -f html -t rst IntroductiontoConfiguration.html.out -o ../../../docs/rst/IntroductiontoConfiguration.html.out.rst
pandoc -f html -t rst ConfigurationTemplates.html.out -o ../../../docs/rst/ConfigurationTemplates.html.out.rst
pandoc -f html -t rst ConfigurationMacros.html.out -o ../../../docs/rst/ConfigurationMacros.html.out.rst
pandoc -f html -t rst UserPrioritiesandNegotiation.html.out -o ../../../docs/rst/UserPrioritiesandNegotiation.html.out.rst
pandoc -f html -t rst PolicyConfigurationforExecuteHostsandforSubmitHosts.html.out -o ../../../docs/rst/PolicyConfigurationforExecuteHostsandforSubmitHosts.html.out.rst
pandoc -f html -t rst Security.html.out -o ../../../docs/rst/Security.html.out.rst
pandoc -f html -t rst NetworkingincludessectionsonPortUsageandCCB.html.out -o ../../../docs/rst/NetworkingincludessectionsonPortUsageandCCB.html.out.rst
pandoc -f html -t rst TheCheckpointServer.html.out -o ../../../docs/rst/TheCheckpointServer.html.out.rst
pandoc -f html -t rst DaemonCore.html.out -o ../../../docs/rst/DaemonCore.html.out.rst
pandoc -f html -t rst Monitoring.html.out -o ../../../docs/rst/Monitoring.html.out.rst
pandoc -f html -t rst TheHighAvailabilityofDaemons.html.out -o ../../../docs/rst/TheHighAvailabilityofDaemons.html.out.rst
pandoc -f html -t rst SettingUpforSpecialEnvironments.html.out -o ../../../docs/rst/SettingUpforSpecialEnvironments.html.out.rst
pandoc -f html -t rst JavaSupportInstallation.html.out -o ../../../docs/rst/JavaSupportInstallation.html.out.rst
pandoc -f html -t rst SettingUptheVMandDockerUniverses.html.out -o ../../../docs/rst/SettingUptheVMandDockerUniverses.html.out.rst
pandoc -f html -t rst SingularitySupport.html.out -o ../../../docs/rst/SingularitySupport.html.out.rst
pandoc -f html -t rst PowerManagement.html.out -o ../../../docs/rst/PowerManagement.html.out.rst

# Miscellaneous Concepts
pandoc -f html -t rst MiscellaneousConcepts.html.out -o ../../../docs/rst/MiscellaneousConcepts.html.out.rst
pandoc -f html -t rst HTCondorsClassAdMechanism.html.out -o ../../../docs/rst/HTCondorsClassAdMechanism.html.out.rst
pandoc -f html -t rst HTCondorsCheckpointMechanism.html.out -o ../../../docs/rst/HTCondorsCheckpointMechanism.html.out.rst
pandoc -f html -t rst ComputingOnDemandCOD.html.out -o ../../../docs/rst/ComputingOnDemandCOD.html.out.rst
pandoc -f html -t rst Hooks.html.out -o ../../../docs/rst/Hooks.html.out.rst
pandoc -f html -t rst LogginginHTCondor.html.out -o ../../../docs/rst/LogginginHTCondor.html.out.rst

# Grid Computing
pandoc -f html -t rst GridComputing.html.out -o ../../../docs/rst/GridComputing.html.out.rst
pandoc -f html -t rst Introduction2.html.out -o ../../../docs/rst/Introduction2.html.out.rst
pandoc -f html -t rst ConnectingHTCondorPoolswithFlocking.html.out -o ../../../docs/rst/ConnectingHTCondorPoolswithFlocking.html.out.rst
pandoc -f html -t rst TheGridUniverse.html.out -o ../../../docs/rst/TheGridUniverse.html.out.rst
pandoc -f html -t rst TheHTCondorJobRouter.html.out -o ../../../docs/rst/TheHTCondorJobRouter.html.out.rst

# Cloud Computing
pandoc -f html -t rst CloudComputing.html.out -o ../../../docs/rst/CloudComputing.html.out.rst
pandoc -f html -t rst Introduction3.html.out -o ../../../docs/rst/Introduction3.html.out.rst
pandoc -f html -t rst HTCondorAnnexUsersGuide.html.out -o ../../../docs/rst/HTCondorAnnexUsersGuide.html.out.rst
pandoc -f html -t rst UsingCondorannexfortheFirstTime.html.out -o ../../../docs/rst/UsingCondorannexfortheFirstTime.html.out.rst
pandoc -f html -t rst HTCondorAnnexCustomizationGuide.html.out -o ../../../docs/rst/HTCondorAnnexCustomizationGuide.html.out.rst
pandoc -f html -t rst HTCondorAnnexConfiguration.html.out -o ../../../docs/rst/HTCondorAnnexConfiguration.html.out.rst

# Application Programming Interfaces (APIs)
pandoc -f html -t rst ApplicationProgrammingInterfacesAPIs.html.out -o ../../../docs/rst/ApplicationProgrammingInterfacesAPIs.html.out.rst
pandoc -f html -t rst PythonBindings.html.out -o ../../../docs/rst/PythonBindings.html.out.rst
pandoc -f html -t rst Chirp.html.out -o ../../../docs/rst/Chirp.html.out.rst
pandoc -f html -t rst TheHTCondorUserandJobLogReaderAPI.html.out -o ../../../docs/rst/TheHTCondorUserandJobLogReaderAPI.html.out.rst
pandoc -f html -t rst TheCommandLineInterface.html.out -o ../../../docs/rst/TheCommandLineInterface.html.out.rst
pandoc -f html -t rst TheDRMAAAPI.html.out -o ../../../docs/rst/TheDRMAAAPI.html.out.rst

# Platform-Specific Information
pandoc -f html -t rst PlatformSpecificInformation.html.out -o ../../../docs/rst/PlatformSpecificInformation.html.out.rst
pandoc -f html -t rst Linux.html.out -o ../../../docs/rst/Linux.html.out.rst
pandoc -f html -t rst MicrosoftWindows.html.out -o ../../../docs/rst/MicrosoftWindows.html.out.rst
pandoc -f html -t rst MacintoshOSX.html.out -o ../../../docs/rst/MacintoshOSX.html.out.rst

# Frequently Asked Questions
pandoc -f html -t rst FrequentlyAskedQuestionsFAQ.html.out -o ../../../docs/rst/FrequentlyAskedQuestionsFAQ.html.out.rst

# Contrib and Source Modules
pandoc -f html -t rst ContribandSourceModules.html.out -o ../../../docs/rst/ContribandSourceModules.html.out.rst
pandoc -f html -t rst Introduction4.html.out -o ../../../docs/rst/Introduction4.html.out.rst
pandoc -f html -t rst TheHTCondorViewClientContribModule.html.out -o ../../../docs/rst/TheHTCondorViewClientContribModule.html.out.rst
pandoc -f html -t rst JobMonitorLogViewer.html.out -o ../../../docs/rst/JobMonitorLogViewer.html.out.rst

# Version History and Release Notes
pandoc -f html -t rst VersionHistoryandReleaseNotes.html.out -o ../../../docs/rst/VersionHistoryandReleaseNotes.html.out.rst
pandoc -f html -t rst IntroductiontoHTCondorVersions.html.out -o ../../../docs/rst/IntroductiontoHTCondorVersions.html.out.rst
pandoc -f html -t rst Upgradingfromthe86seriestothe88seriesofHTCondor.html.out -o ../../../docs/rst/Upgradingfromthe86seriestothe88seriesofHTCondor.html.out.rst
pandoc -f html -t rst DevelopmentReleaseSeries89.html.out -o ../../../docs/rst/DevelopmentReleaseSeries89.html.out.rst
pandoc -f html -t rst StableReleaseSeries88.html.out -o ../../../docs/rst/StableReleaseSeries88.html.out.rst
pandoc -f html -t rst DevelopmentReleaseSeries87.html.out -o ../../../docs/rst/DevelopmentReleaseSeries87.html.out.rst
pandoc -f html -t rst StableReleaseSeries86.html.out -o ../../../docs/rst/StableReleaseSeries86.html.out.rst

# Command Reference Manual (man-pages)
pandoc -f html -t rst CommandReferenceManualmanpages.html.out -o ../../../docs/rst/CommandReferenceManualmanpages.html.out.rst
pandoc -f html -t rst Boscocluster.html.out -o ../../../docs/rst/Boscocluster.html.out.rst
pandoc -f html -t rst Boscofindplatform.html.out -o ../../../docs/rst/Boscofindplatform.html.out.rst
pandoc -f html -t rst Boscoinstall.html.out -o ../../../docs/rst/Boscoinstall.html.out.rst
pandoc -f html -t rst Boscosshstart.html.out -o ../../../docs/rst/Boscosshstart.html.out.rst
pandoc -f html -t rst Boscostart.html.out -o ../../../docs/rst/Boscostart.html.out.rst
pandoc -f html -t rst Boscostop.html.out -o ../../../docs/rst/Boscostop.html.out.rst
pandoc -f html -t rst Boscouninstall.html.out -o ../../../docs/rst/Boscouninstall.html.out.rst
pandoc -f html -t rst Condoradvertise.html.out -o ../../../docs/rst/Condoradvertise.html.out.rst
pandoc -f html -t rst Condorannex.html.out -o ../../../docs/rst/Condorannex.html.out.rst
pandoc -f html -t rst Condorcheckpoint.html.out -o ../../../docs/rst/Condorcheckpoint.html.out.rst
pandoc -f html -t rst Condorcheckuserlogs.html.out -o ../../../docs/rst/Condorcheckuserlogs.html.out.rst
pandoc -f html -t rst Condorchirp.html.out -o ../../../docs/rst/Condorchirp.html.out.rst
pandoc -f html -t rst Condorcod.html.out -o ../../../docs/rst/Condorcod.html.out.rst
pandoc -f html -t rst Condorcompile.html.out -o ../../../docs/rst/Condorcompile.html.out.rst
pandoc -f html -t rst Condorconfigure.html.out -o ../../../docs/rst/Condorconfigure.html.out.rst
pandoc -f html -t rst Condorconfigval.html.out -o ../../../docs/rst/Condorconfigval.html.out.rst
pandoc -f html -t rst Condorcontinue.html.out -o ../../../docs/rst/Condorcontinue.html.out.rst
pandoc -f html -t rst Condorconverthistory.html.out -o ../../../docs/rst/Condorconverthistory.html.out.rst
pandoc -f html -t rst Condordagman.html.out -o ../../../docs/rst/Condordagman.html.out.rst
pandoc -f html -t rst Condordagmanmetricsreporter.html.out -o ../../../docs/rst/Condordagmanmetricsreporter.html.out.rst
pandoc -f html -t rst Condordrain.html.out -o ../../../docs/rst/Condordrain.html.out.rst
pandoc -f html -t rst Condorfetchlog.html.out -o ../../../docs/rst/Condorfetchlog.html.out.rst
pandoc -f html -t rst Condorfindhost.html.out -o ../../../docs/rst/Condorfindhost.html.out.rst
pandoc -f html -t rst Condorgatherinfo.html.out -o ../../../docs/rst/Condorgatherinfo.html.out.rst
pandoc -f html -t rst Condorgpudiscovery.html.out -o ../../../docs/rst/Condorgpudiscovery.html.out.rst
pandoc -f html -t rst Condorhistory.html.out -o ../../../docs/rst/Condorhistory.html.out.rst
pandoc -f html -t rst Condorhold.html.out -o ../../../docs/rst/Condorhold.html.out.rst
pandoc -f html -t rst Condorinstall.html.out -o ../../../docs/rst/Condorinstall.html.out.rst
pandoc -f html -t rst Condorjobrouterinfo.html.out -o ../../../docs/rst/Condorjobrouterinfo.html.out.rst
pandoc -f html -t rst Condormaster.html.out -o ../../../docs/rst/Condormaster.html.out.rst
pandoc -f html -t rst Condornow.html.out -o ../../../docs/rst/Condornow.html.out.rst
pandoc -f html -t rst Condoroff.html.out -o ../../../docs/rst/Condoroff.html.out.rst
pandoc -f html -t rst Condoron.html.out -o ../../../docs/rst/Condoron.html.out.rst
pandoc -f html -t rst Condorping.html.out -o ../../../docs/rst/Condorping.html.out.rst
pandoc -f html -t rst Condorpooljobreport.html.out -o ../../../docs/rst/Condorpooljobreport.html.out.rst
pandoc -f html -t rst Condorpower.html.out -o ../../../docs/rst/Condorpower.html.out.rst
pandoc -f html -t rst Condorpreen.html.out -o ../../../docs/rst/Condorpreen.html.out.rst
pandoc -f html -t rst Condorprio.html.out -o ../../../docs/rst/Condorprio.html.out.rst
pandoc -f html -t rst Condorprocd.html.out -o ../../../docs/rst/Condorprocd.html.out.rst
pandoc -f html -t rst Condorqedit.html.out -o ../../../docs/rst/Condorqedit.html.out.rst
pandoc -f html -t rst Condorq.html.out -o ../../../docs/rst/Condorq.html.out.rst
pandoc -f html -t rst Condorqsub.html.out -o ../../../docs/rst/Condorqsub.html.out.rst
pandoc -f html -t rst Condorreconfig.html.out -o ../../../docs/rst/Condorreconfig.html.out.rst
pandoc -f html -t rst Condorrelease.html.out -o ../../../docs/rst/Condorrelease.html.out.rst
pandoc -f html -t rst Condorreschedule.html.out -o ../../../docs/rst/Condorreschedule.html.out.rst
pandoc -f html -t rst Condorrestart.html.out -o ../../../docs/rst/Condorrestart.html.out.rst
pandoc -f html -t rst Condorrmdir.html.out -o ../../../docs/rst/Condorrmdir.html.out.rst
pandoc -f html -t rst Condorrm.html.out -o ../../../docs/rst/Condorrm.html.out.rst
pandoc -f html -t rst Progcondorrouterhistory.html.out -o ../../../docs/rst/Condorrouterhistory.html.out.rst
pandoc -f html -t rst Progcondorrouterq.html.out -o ../../../docs/rst/Condorrouterq.html.out.rst
pandoc -f html -t rst Condorrouterrm.html.out -o ../../../docs/rst/Condorrouterrm.html.out.rst
pandoc -f html -t rst Condorrun.html.out -o ../../../docs/rst/Condorrun.html.out.rst
pandoc -f html -t rst Condorsetshutdown.html.out -o ../../../docs/rst/Condorsetshutdown.html.out.rst
pandoc -f html -t rst CondorshadowExitCodes.html.out -o ../../../docs/rst/CondorshadowExitCodes.html.out.rst
pandoc -f html -t rst Condorsos.html.out -o ../../../docs/rst/Condorsos.html.out.rst
pandoc -f html -t rst Condorsshtojob.html.out -o ../../../docs/rst/Condorsshtojob.html.out.rst
pandoc -f html -t rst Condorstats.html.out -o ../../../docs/rst/Condorstats.html.out.rst
pandoc -f html -t rst Condorstatus.html.out -o ../../../docs/rst/Condorstatus.html.out.rst
pandoc -f html -t rst Condorstorecred.html.out -o ../../../docs/rst/Condorstorecred.html.out.rst
pandoc -f html -t rst Condorsubmitdag.html.out -o ../../../docs/rst/Condorsubmitdag.html.out.rst
pandoc -f html -t rst Condorsubmit.html.out -o ../../../docs/rst/Condorsubmit.html.out.rst
pandoc -f html -t rst Condorsuspend.html.out -o ../../../docs/rst/Condorsuspend.html.out.rst
pandoc -f html -t rst Condortail.html.out -o ../../../docs/rst/Condortail.html.out.rst
pandoc -f html -t rst Condortop.html.out -o ../../../docs/rst/Condortop.html.out.rst
pandoc -f html -t rst Condortransferdata.html.out -o ../../../docs/rst/Condortransferdata.html.out.rst
pandoc -f html -t rst Condortransformads.html.out -o ../../../docs/rst/Condortransformads.html.out.rst
pandoc -f html -t rst Condorupdatemachinead.html.out -o ../../../docs/rst/Condorupdatemachinead.html.out.rst
pandoc -f html -t rst Condorupdatesstats.html.out -o ../../../docs/rst/Condorupdatesstats.html.out.rst
pandoc -f html -t rst Condorurlfetch.html.out -o ../../../docs/rst/Condorurlfetch.html.out.rst
pandoc -f html -t rst Condoruserlog.html.out -o ../../../docs/rst/Condoruserlog.html.out.rst
pandoc -f html -t rst Condoruserprio.html.out -o ../../../docs/rst/Condoruserprio.html.out.rst
pandoc -f html -t rst Condorvacate.html.out -o ../../../docs/rst/Condorvacate.html.out.rst
pandoc -f html -t rst Condorvacatejob.html.out -o ../../../docs/rst/Condorvacatejob.html.out.rst
pandoc -f html -t rst Condorversion.html.out -o ../../../docs/rst/Condorversion.html.out.rst
pandoc -f html -t rst Condorwait.html.out -o ../../../docs/rst/Condorwait.html.out.rst
pandoc -f html -t rst Condorwho.html.out -o ../../../docs/rst/Condorwho.html.out.rst
pandoc -f html -t rst giddalloc.html.out -o ../../../docs/rst/giddalloc.html.out.rst
pandoc -f html -t rst procdctl.html.out -o ../../../docs/rst/procdctl.html.out.rst

# ClassAd Attributes
pandoc -f html -t rst ClassAdAttributes.html.out -o ../../../docs/rst/ClassAdAttributes.html.out.rst
pandoc -f html -t rst ClassAdTypes.html.out -o ../../../docs/rst/ClassAdTypes.html.out.rst
pandoc -f html -t rst JobClassAdAttributes.html.out -o ../../../docs/rst/JobClassAdAttributes.html.out.rst
pandoc -f html -t rst MachineClassAdAttributes.html.out -o ../../../docs/rst/MachineClassAdAttributes.html.out.rst
pandoc -f html -t rst DaemonMasterClassAdAttributes.html.out -o ../../../docs/rst/DaemonMasterClassAdAttributes.html.out.rst
pandoc -f html -t rst SchedulerClassAdAttributes.html.out -o ../../../docs/rst/SchedulerClassAdAttributes.html.out.rst
pandoc -f html -t rst NegotiatorClassAdAttributes.html.out -o ../../../docs/rst/NegotiatorClassAdAttributes.html.out.rst
pandoc -f html -t rst SubmitterClassAdAttributes.html.out -o ../../../docs/rst/SubmitterClassAdAttributes.html.out.rst
pandoc -f html -t rst DefragClassAdAttributes.html.out -o ../../../docs/rst/DefragClassAdAttributes.html.out.rst
pandoc -f html -t rst CollectorClassAdAttributes.html.out -o ../../../docs/rst/CollectorClassAdAttributes.html.out.rst
pandoc -f html -t rst ClassAdAttributesAddedbytheCondorcollector.html.out -o ../../../docs/rst/ClassAdAttributesAddedbytheCondorcollector.html.out.rst
pandoc -f html -t rst DaemonCoreStatisticsAttributes.html.out -o ../../../docs/rst/DaemonCoreStatisticsAttributes.html.out.rst

# Codes and Other Needed Values
pandoc -f html -t rst CodesandOtherNeededValues.html.out -o ../../../docs/rst/CodesandOtherNeededValues.html.out.rst
pandoc -f html -t rst JobEventLogCodes.html.out -o ../../../docs/rst/JobEventLogCodes.html.out.rst
pandoc -f html -t rst WellknownPortNumbers.html.out -o ../../../docs/rst/WellknownPortNumbers.html.out.rst
pandoc -f html -t rst DaemonCoreCommandNumbers.html.out -o ../../../docs/rst/DaemonCoreCommandNumbers.html.out.rst
pandoc -f html -t rst DaemonCoreDaemonExitCodes.html.out -o ../../../docs/rst/DaemonCoreDaemonExitCodes.html.out.rst

cd ..