<?php

/**
 * @package   OpenEMR
 *
 * @link      https://www.open-emr.org
 *
 * @author    Igor Mukhin <igor.mukhin@gmail.com>
 * @copyright Copyright (c) 2025 OpenCoreEMR Inc <https://opencoreemr.com/>
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

namespace OpenEMR\Tests\Isolated\Common\Twig;

use OpenEMR\Common\Twig\TwigExtension;
use OpenEMR\Core\Kernel;
use OpenEMR\Core\OEGlobalsBag;
use PHPUnit\Framework\Attributes\Group;
use PHPUnit\Framework\TestCase;

#[Group('isolated')]
#[Group('twig')]
class TwigExtensionIsolatedTest extends TestCase
{
    public function testGetGlobals(): void
    {
        $kernel = new Kernel('/var/www/tabemr', '/tabemr');
        $bag = new OEGlobalsBag([]);
        $extension = new TwigExtension($bag, $kernel);

        $expectedTwigGlobals = [
            'assets_dir' => '/tabemr/public/assets',
            'srcdir' => '/var/www/tabemr/library',
            'rootdir' => '/tabemr/interface',
            'webroot' => '/tabemr',
            'assetVersion' => null,
            'session' => [],
        ];

        $twigGlobals = $extension->getGlobals();
        $this->assertEquals($expectedTwigGlobals, $twigGlobals);
    }
}
