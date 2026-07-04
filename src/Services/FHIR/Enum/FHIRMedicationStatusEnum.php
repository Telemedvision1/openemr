<?php

/*
 * FHIRMedicationStatusEnum.php
 * @package tabemr
 * @link      https://www.open-emr.org
 * @author    Stephen Nielson <snielson@discoverandchange.com>
 * @copyright Copyright (c) 2025 Stephen Nielson <snielson@discoverandchange.com>
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

namespace OpenEMR\Services\FHIR\Enum;

enum FHIRMedicationStatusEnum: string
{
    case ACTIVE = "active";
    case ON_HOLD = "on-hold";
    case CANCELLED = "cancelled";
    case COMPLETED = "completed";
    case ENTERED_IN_ERROR = "entered-in-error";
    case STOPPED = "stopped";
    case DRAFT = "draft";
    case UNKNOWN = "unknown";
}
