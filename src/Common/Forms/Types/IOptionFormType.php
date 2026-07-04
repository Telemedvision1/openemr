<?php

/*
 * IOEFormType.php
 * @package tabemr
 * @link      https://www.open-emr.org
 * @author    Stephen Nielson <snielson@discoverandchange.com>
 * @copyright Copyright (c) 2025 Stephen Nielson <snielson@discoverandchange.com>
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

namespace OpenEMR\Common\Forms\Types;

interface IOptionFormType {
    public function buildPrintView($frow, $currvalue, $value_allowed = true);
    public function buildPlaintextView($frow, $currvalue);
    public function buildDisplayView($frow, $currvalue): string;
    public function buildFormView($frow, $currvalue): string;
}
