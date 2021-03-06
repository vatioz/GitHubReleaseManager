function New-GitHubRelease {
<#
    .SYNOPSIS
    Create a new release for a repository

    .DESCRIPTION
    Create a new release for a repository

    .PARAMETER Repository
    The name of the repository

    .PARAMETER Name
    The name of the release

    .PARAMETER Description
    Text describing the contents of the tag.

    .PARAMETER Target
    Specifies the commitish value that determines where the Git tag is created from.
    Can be any branch or commit SHA. Unused if the Git tag already exists.
    Default: the repository's default branch (usually master).

    .PARAMETER Tag
    The name of the tag

    .PARAMETER Asset
    An array of Assets to upload with the release.

    An asset should be in the form of a hashtable and must contain the following keys:

    Path - The Path of the asset that will be uploaded
    Content-Type - The Content-Type type of the asset that will be uploaded

    For example, the hashtable would be formed like this:

    @{

        "Path" = "C:\Assets\Asset-v1.0.zip"
        "Content-Type" = "application/zip"

    }

    For a list of supplorted content types see the following url -> https://www.iana.org/assignments/media-types/media-types.xhtml

    .PARAMETER Draft
    Make the release a draft

    .PARAMETER Prerelease
    Make the release a prerelease

    .INPUTS
    System.String
    Switch
    Hashtable

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-GitHubRelease -Repository MyRepository -Name TestRelease -Description "Test v1.0 release" -Target master -Tag v1.0

    .EXAMPLE
    New-GitHubRelease -Repository MyRepository -Name TestRelease -Description "Test v1.0 release" -Target master -Tag v1.0 -Draft

    .EXAMPLE
    New-GitHubRelease -Repository MyRepository -Name TestRelease -Description "Test v1.0 release" -Target master -Tag v1.0 -Prerelease

    .EXAMPLE
    $Asset = @{
        "Path" = ".\Release\TestRelease-0.1.0.zip"
        "Content-Type" = "application/zip"
    }
    New-GitHubRelease -Repository MyRepository -Name TestRelease -Description "Test v1.0 release" -Target master -Tag v1.0 -Asset $Asset


#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Repository,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [Parameter(Mandatory=$false, Position=2)]
        [ValidateNotNullOrEmpty()]
        [String]$Description,

        [Parameter(Mandatory=$false, Position=3)]
        [ValidateNotNullOrEmpty()]
        [String]$Target,

        [Parameter(Mandatory=$true, Position=4)]
        [ValidateNotNullOrEmpty()]
        [String]$Tag,

        [Parameter(Mandatory=$false, Position=5)]
        [ValidateNotNullOrEmpty()]
        [Hashtable[]]$Asset,

        [Parameter(Mandatory=$false, Position=6)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.SwitchParameter]$Draft,

        [Parameter(Mandatory=$false, Position=7)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.SwitchParameter]$Prerelease

    )

    try {

        # --- Grab the sessionstate variable & test throw if it is null
        $SessionInfo = Get-GitHubSessionInformation -Verbose:$VerbosePreference

        $Body = [PSCustomObject] @{

            tag_name = $Tag
            target_commitish = $Target
            name = $Name
            body = $Description
            draft = $Draft.IsPresent
            prerelease = $Prerelease.IsPresent

        }

        $URI = "/repos/$($SessionInfo.Username)/$($Repository)/releases"

        if ($PSCmdlet.ShouldProcess($Repository)) {

            # --- Create the release
            $Response = Invoke-GitHubRestMethod -Method POST -URI $URI -Body ($Body | ConvertTo-JSON) -Verbose:$VerbosePreference

            # --- If the Assets parameter is passed upload each file
            if ($PSBoundParameters.ContainsKey("Asset")) {

                foreach ($Item in $Asset) {

                    if (!($Item.ContainsKey("Path") -and $Item.ContainsKey("Content-Type"))) {

                        throw "The Assets parameter is not correct. See function help for more information."

                    }

                    # --- Retrieve parameters from hashtable
                    $Path = $Item.Get_Item("Path")
                    $ContentType = $Item.Get_Item("Content-Type")

                    # --- Execute Request
                    $ResolvedAsset = Get-Item -LiteralPath $Path
                    $UploadURI = "/repos/$($SessionInfo.Username)/$($Repository)/releases/$($Response.id)/assets?name=$($ResolvedAsset.Name)"
                    Write-Verbose -Message "Uploading asset $($ResolvedAsset.FullName)"
                    Invoke-GitHubRestMethod -Method POST -URI $UploadURI -InFile $ResolvedAsset.FullName -ContentType $ContentType -Verbose:$VerbosePreference | Out-Null

                }

            }
            
            Write-Output $Response

        }

    }
    catch [Exception]{

        throw $_.Exception

    }

}
