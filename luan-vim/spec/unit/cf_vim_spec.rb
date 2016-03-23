require 'spec_helper'

describe 'cf-vim' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:vimfiles) do
    ::File.join(
      runner.node['sprout']['home'],
      runner.node['workspace_directory'], 'vimfiles'
    )
  end
  let(:dotvim) { ::File.join(runner.node['sprout']['home'], '.vim') }

  context 'when ~/.vim doesn\'t exist, or is a symlink' do
    before do
      stub_command(/test -d .*/).and_return(false)
      runner.converge(described_recipe)
    end

    it 'checks out vimfiles' do
      expect(runner).to checkout_git(vimfiles).with(
        repository: 'http://github.com/luan/vimfiles.git',
        revision: 'master',
        user: runner.node['sprout']['user'],
        enable_submodules: true
      )
    end

    it 'links the .vim folder' do
      expect(runner).to create_link(dotvim).with(
        to: vimfiles,
        user: runner.node['sprout']['user']
      )
    end

    it 'executes the install script' do
      expect(runner).to run_execute('./install').with(
        command: './install && tput reset',
        cwd: dotvim,
        user: runner.node['sprout']['user']
      )
    end

    it 'does not attempt to delete ~/.vim' do
      expect(runner).to_not delete_directory(dotvim)
    end
  end

  context 'when a ~/.vim folder exists' do
    before do
      stub_command(/test -d .*/).and_return(true)
      runner.converge(described_recipe)
    end

    it 'deletes it' do
      expect(runner).to delete_directory(dotvim)
    end
  end
end
