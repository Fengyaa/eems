

function [proposal,pi1_pi0] = ...
    move_mVoronoi(kernel,params,qVoronoi,mVoronoi,Data,Graph,schedule)

%%%%%%%%%%
type = 6;%
%%%%%%%%%%

tile = schedule.paramtoupdate{type};

mSeeds = mVoronoi.mSeeds;
qSeeds = qVoronoi.qSeeds;
mSeeds(tile,:) = rnorm(mSeeds(tile,:),params.mSeedsProposalS2);

proposal = struct('type',{type},'subtype',{1},'mSeeds',{mSeeds});

%% Contain every center to lie within the habitat
if min(is_in_habitat(mVoronoi.habitat,mSeeds))
  mRates = realpow(10,mVoronoi.mEffcts + params.mrateMu);
  qRates = realpow(10,qVoronoi.qEffcts); % qrateMu = 0.0;
  [qValues,mValues] = ...
    average_rates(Graph,qRates,mRates,qSeeds,mSeeds,mVoronoi.Demes);
  proposal.kernel = resistance_kernel(Data,Graph,mValues,qValues);
  pi1_pi0 = 0;
else
  pi1_pi0 = -Inf;
end
