<?php

/*
 * FHIRDomainModelSerializationCleanupTrait.php
 * @package tabemr
 * @link      https://www.open-emr.org
 * @author    Stephen Nielson <snielson@discoverandchange.com>
 * @copyright Copyright (c) 2025 Stephen Nielson <snielson@discoverandchange.com>
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

namespace OpenEMR\FHIR\DomainModels;

trait FHIRDomainModelSerializationCleanupTrait
{
    public function jsonSerialize(): array
    {
        $json = parent::jsonSerialize();
        if (isset($json['resourceType'])) {
            unset($json['resourceType']);
        }
        return $json;
    }
}
