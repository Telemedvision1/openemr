<?php

/*
 * OpenEMRFHIRDateTime.php
 * @package tabemr
 * @link      https://www.open-emr.org
 * @author    Stephen Nielson <snielson@discoverandchange.com>
 * @copyright Copyright (c) 2025 Stephen Nielson <snielson@discoverandchange.com>
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

namespace OpenEMR\FHIR\DomainModels;

use OpenEMR\FHIR\R4\FHIRElement\FHIRDateTime;

class OpenEMRFHIRDateTime extends FHIRDateTime
{
    use FHIRDomainModelBasicDataTypeExtensionTrait;
}
