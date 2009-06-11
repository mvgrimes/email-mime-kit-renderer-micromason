use Module::Build;

my $build = Module::Build->new(
    module_name        => 'Email::MIME::Kit::Renderer::MicroMason',
    license            => 'perl',
    create_readme      => 1,
    create_makefile_pl => 'passthrough',
    requires           => {
        'perl'             => '5.008',
        'Text::MicroMason' => 2.0,
        'Email::MIME::Kit' => 2.0,
    },

    build_requires => { 'Test::More ' => 0, },
);

$build->create_build_script;

