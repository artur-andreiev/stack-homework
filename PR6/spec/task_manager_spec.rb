# frozen_string_literal: true

require 'rspec'
require 'fileutils'
require_relative '../task_manager'

RSpec.describe TaskManager do
  let(:test_file) { 'test_tasks.json' }
  let(:manager) { TaskManager.new(test_file) }

  before(:each) do
    FileUtils.rm_f(test_file) # Видаляємо тестовий файл перед кожним тестом
  end

  after(:all) do
    FileUtils.rm_f('test_tasks.json') # Прибираємо тестовий файл після всіх тестів
  end

  describe '#add_task' do
    it 'adds a task with valid input' do
      manager.add_task('Test Task', '01.01.2025')
      expect(manager.tasks.size).to eq(1)
      expect(manager.tasks.first[:title]).to eq('Test Task')
      expect(manager.tasks.first[:deadline]).to eq('01.01.2025')
      expect(manager.tasks.first[:status]).to eq('incomplete')
    end

    it 'does not add a task with invalid date' do
      manager.add_task('Invalid Task', 'invalid-date')
      expect(manager.tasks).to be_empty
    end
  end

  describe '#delete_task' do
    it 'deletes a task by ID' do
      manager.add_task('Task to delete', '01.01.2025')
      task_id = manager.tasks.first[:id]
      manager.delete_task(task_id)
      expect(manager.tasks).to be_empty
    end

    it 'does nothing if task ID is not found' do
      manager.add_task('Task 1', '01.01.2025')
      manager.delete_task(999)
      expect(manager.tasks.size).to eq(1)
    end
  end

  describe '#edit_task' do
    it 'edits a task title' do
      manager.add_task('Old Title', '01.01.2025')
      task_id = manager.tasks.first[:id]
      manager.edit_task(task_id, title: 'New Title')
      expect(manager.tasks.first[:title]).to eq('New Title')
    end

    it 'edits a task deadline' do
      manager.add_task('Task', '01.01.2025')
      task_id = manager.tasks.first[:id]
      manager.edit_task(task_id, deadline: '02.02.2025')
      expect(manager.tasks.first[:deadline]).to eq('02.02.2025')
    end

    it 'does nothing for invalid task ID' do
      manager.add_task('Task', '01.01.2025')
      manager.edit_task(999, title: 'New Title')
      expect(manager.tasks.first[:title]).to eq('Task')
    end
  end

  describe '#filter_tasks' do
    before(:each) do
      manager.add_task('Task 1', '01.01.2025')
      manager.add_task('Task 2', '01.01.2024')
      manager.add_task('Task 3', '01.01.2026')
      manager.tasks[0][:status] = 'complete'
      manager.save_tasks
    end

    it 'filters tasks by status' do
      filtered = manager.filter_tasks(status: 'complete')
      expect(filtered.size).to eq(1)
      expect(filtered.first[:title]).to eq('Task 1')
    end

    it 'filters tasks by deadline' do
      filtered = manager.filter_tasks(before: '01.01.2025')
      expect(filtered.size).to eq(1)
      expect(filtered.first[:title]).to eq('Task 2')
    end

    it 'filters tasks by status and deadline' do
      filtered = manager.filter_tasks(status: 'complete', before: '01.01.2025')
      expect(filtered).to be_empty
    end
  end

  describe '#load_tasks' do
    it 'loads tasks from an existing file' do
      tasks = [
        { id: 1, title: 'Task 1', deadline: '01.01.2025', status: 'incomplete' }
      ]
      File.write(test_file, JSON.pretty_generate(tasks))
      loaded_manager = TaskManager.new(test_file)
      expect(loaded_manager.tasks).to eq(tasks)
    end

    it 'starts with an empty task list if file does not exist' do
      expect(manager.tasks).to be_empty
    end
  end
end
