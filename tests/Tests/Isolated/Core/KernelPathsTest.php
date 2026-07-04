<?php

/**
 * @package   OpenEMR
 *
 * @link      https://www.open-emr.org
 *
 * @author    Michael A. Smith <michael@opencoreemr.com>
 * @copyright Copyright (c) 2026 OpenCoreEMR Inc
 * @license   https://github.com/tabemr/tabemr/blob/master/LICENSE GNU General Public License 3
 */

declare(strict_types=1);

namespace OpenEMR\Tests\Isolated\Core;

use OpenEMR\Core\Kernel;
use PHPUnit\Framework\Attributes\Group;
use PHPUnit\Framework\TestCase;

#[Group('isolated')]
#[Group('core')]
class KernelPathsTest extends TestCase
{
    private Kernel $kernel;

    protected function setUp(): void
    {
        $this->kernel = new Kernel('/var/www/tabemr', '/tabemr');
    }

    // ---- Web paths --------------------------------------------------------

    public function testGetWebRoot(): void
    {
        $this->assertSame('/tabemr', $this->kernel->getWebRoot());
    }

    public function testGetWebRootEmpty(): void
    {
        $kernel = new Kernel('/var/www/tabemr', '');
        $this->assertSame('', $kernel->getWebRoot());
    }

    public function testGetRootDir(): void
    {
        $this->assertSame('/tabemr/interface', $this->kernel->getRootDir());
    }

    public function testGetAssetsRelative(): void
    {
        $this->assertSame('/tabemr/public/assets', $this->kernel->getAssetsRelative());
    }

    public function testGetThemesRelative(): void
    {
        $this->assertSame('/tabemr/public/themes', $this->kernel->getThemesRelative());
    }

    public function testGetImagesRelative(): void
    {
        $this->assertSame('/tabemr/public/images', $this->kernel->getImagesRelative());
    }

    // ---- Filesystem paths -------------------------------------------------

    public function testGetProjectDir(): void
    {
        $this->assertSame('/var/www/tabemr', $this->kernel->getProjectDir());
    }

    public function testGetSrcDir(): void
    {
        $this->assertSame('/var/www/tabemr/library', $this->kernel->getSrcDir());
    }

    public function testGetIncludeRoot(): void
    {
        $this->assertSame('/var/www/tabemr/interface', $this->kernel->getIncludeRoot());
    }

    public function testGetVendorDir(): void
    {
        $this->assertSame('/var/www/tabemr/vendor', $this->kernel->getVendorDir());
    }

    public function testGetTemplateDir(): void
    {
        $this->assertSame('/var/www/tabemr/templates/', $this->kernel->getTemplateDir());
    }

    public function testGetImagesAbsolute(): void
    {
        $this->assertSame('/var/www/tabemr/public/images', $this->kernel->getImagesAbsolute());
    }

    public function testGetSitesBase(): void
    {
        $this->assertSame('/var/www/tabemr/sites', $this->kernel->getSitesBase());
    }

    // ---- Site-specific paths ----------------------------------------------

    public function testGetSiteDir(): void
    {
        $this->assertSame('/var/www/tabemr/sites/default', $this->kernel->getSiteDir('default'));
    }

    public function testGetSiteWebRoot(): void
    {
        $this->assertSame('/tabemr/sites/default', $this->kernel->getSiteWebRoot('default'));
    }

    // ---- RuntimeException when paths not provided -------------------------

    public function testGetProjectDirThrowsWhenNull(): void
    {
        $kernel = new Kernel();
        $this->expectException(\RuntimeException::class);
        $kernel->getProjectDir();
    }

    public function testGetWebRootThrowsWhenNull(): void
    {
        $kernel = new Kernel();
        $this->expectException(\RuntimeException::class);
        $kernel->getWebRoot();
    }

    // ---- Backward compat: dispatcher-only construction --------------------

    public function testConstructWithDispatcherOnly(): void
    {
        $dispatcher = new \Symfony\Component\EventDispatcher\EventDispatcher();
        $kernel = new Kernel(dispatcher: $dispatcher);
        $this->assertSame($dispatcher, $kernel->getEventDispatcher());
    }
}
