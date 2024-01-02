require_relative '../lib/connect_four'


describe ConnectFour do
  subject(:game) {described.new}
  let(:interface) {game.instance_variable_get(:interface)}
  context 'when game begins' do
    it 'sends appropriate outgoing command messages' do
      inter
    end
  end

end
